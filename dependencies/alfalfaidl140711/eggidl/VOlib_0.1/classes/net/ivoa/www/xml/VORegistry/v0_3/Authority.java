/**
 * Authority.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VORegistry.v0_3;

public class Authority  extends net.ivoa.www.xml.VOResource.v0_10.Resource  implements java.io.Serializable {
    private net.ivoa.www.xml.VOResource.v0_10.ResourceName managingOrg;

    public Authority() {
    }


    /**
     * Gets the managingOrg value for this Authority.
     * 
     * @return managingOrg
     */
    public net.ivoa.www.xml.VOResource.v0_10.ResourceName getManagingOrg() {
        return managingOrg;
    }


    /**
     * Sets the managingOrg value for this Authority.
     * 
     * @param managingOrg
     */
    public void setManagingOrg(net.ivoa.www.xml.VOResource.v0_10.ResourceName managingOrg) {
        this.managingOrg = managingOrg;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Authority)) return false;
        Authority other = (Authority) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.managingOrg==null && other.getManagingOrg()==null) || 
             (this.managingOrg!=null &&
              this.managingOrg.equals(other.getManagingOrg())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getManagingOrg() != null) {
            _hashCode += getManagingOrg().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Authority.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "Authority"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("managingOrg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "managingOrg"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VOResource/v0.10", "ResourceName"));
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
