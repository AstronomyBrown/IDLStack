/**
 * ArrayOfMetaTable.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.SkyPortal;

public class ArrayOfMetaTable  implements java.io.Serializable {
    private net.ivoa.SkyPortal.MetaTable[] metaTable;

    public ArrayOfMetaTable() {
    }


    /**
     * Gets the metaTable value for this ArrayOfMetaTable.
     * 
     * @return metaTable
     */
    public net.ivoa.SkyPortal.MetaTable[] getMetaTable() {
        return metaTable;
    }


    /**
     * Sets the metaTable value for this ArrayOfMetaTable.
     * 
     * @param metaTable
     */
    public void setMetaTable(net.ivoa.SkyPortal.MetaTable[] metaTable) {
        this.metaTable = metaTable;
    }

    public net.ivoa.SkyPortal.MetaTable getMetaTable(int i) {
        return this.metaTable[i];
    }

    public void setMetaTable(int i, net.ivoa.SkyPortal.MetaTable value) {
        this.metaTable[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ArrayOfMetaTable)) return false;
        ArrayOfMetaTable other = (ArrayOfMetaTable) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.metaTable==null && other.getMetaTable()==null) || 
             (this.metaTable!=null &&
              java.util.Arrays.equals(this.metaTable, other.getMetaTable())));
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
        if (getMetaTable() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getMetaTable());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getMetaTable(), i);
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
        new org.apache.axis.description.TypeDesc(ArrayOfMetaTable.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "ArrayOfMetaTable"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("metaTable");
        elemField.setXmlName(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaTable"));
        elemField.setXmlType(new javax.xml.namespace.QName("SkyPortal.ivoa.net", "MetaTable"));
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
