/**
 * ArrayOfDBResource.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package org.us_vo.www;

public class ArrayOfDBResource  implements java.io.Serializable {
    private org.us_vo.www.DBResource[] DBResource;

    public ArrayOfDBResource() {
    }


    /**
     * Gets the DBResource value for this ArrayOfDBResource.
     * 
     * @return DBResource
     */
    public org.us_vo.www.DBResource[] getDBResource() {
        return DBResource;
    }


    /**
     * Sets the DBResource value for this ArrayOfDBResource.
     * 
     * @param DBResource
     */
    public void setDBResource(org.us_vo.www.DBResource[] DBResource) {
        this.DBResource = DBResource;
    }

    public org.us_vo.www.DBResource getDBResource(int i) {
        return this.DBResource[i];
    }

    public void setDBResource(int i, org.us_vo.www.DBResource value) {
        this.DBResource[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfDBResource)) return false;
        ArrayOfDBResource other = (ArrayOfDBResource) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.DBResource==null && other.getDBResource()==null) || 
             (this.DBResource!=null &&
              java.util.Arrays.equals(this.DBResource, other.getDBResource())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getDBResource() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDBResource());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDBResource(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ArrayOfDBResource.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "ArrayOfDBResource"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DBResource");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.us-vo.org", "DBResource"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.us-vo.org", "DBResource"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
